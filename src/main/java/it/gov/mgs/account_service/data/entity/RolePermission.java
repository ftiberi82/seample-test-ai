package it.gov.mgs.account_service.data.entity;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * Associazione molti-a-molti tra {@link Role} e {@link Permission} (tabella ROLE_PERMISSION)
 * modellata tramite chiave composta embedded.
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ROLE_PERMISSION")
public class RolePermission extends AuditedEntity {

    @Embeddable
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class Id implements Serializable {
        @Column(name = "role_id", nullable = false, columnDefinition = "uniqueidentifier")
        private UUID roleId;
        @Column(name = "permission_id", nullable = false, columnDefinition = "uniqueidentifier")
        private UUID permissionId;
    }

    @EmbeddedId
    private Id id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("roleId")
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("permissionId")
    @JoinColumn(name = "permission_id", nullable = false)
    private Permission permission;

}
